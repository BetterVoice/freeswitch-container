#!/usr/bin/env python

"""Start/Stop docker freeSWITCH container

This writes specific IPTables rules due to the
fact that mapping huge port ranges slows down
docker considerably.
"""

from __future__ import print_function
import os, sys, argparse, textwrap
import time
import subprocess

__author__ = "Nodar Nutsubidze"

# The default container to use
CONTAINER="bettervoice/freeswitch-container:1.6.9"

# Default name of the running container
NAME="freeswitch-run"

# IPTables chain
IPT_CHAIN="DOCKER-FREESWITCH"
IPT_MASQ_CHAIN="DOCKER-FREESWITCH-MASQ"

# This will be updated by the script
CONTAINER_IP = None
ARGS = None

def ipt_chain_exists(table, chain):
  """Check if a chain exists

  :param table: The table to look at
  :param chain: The chain to look for
  :return: True if the table/chain pair exists, otherwise False
  """
  ret = os.system("iptables -t {} -L {} > /dev/null 2>&1".format(
    table, chain))
  return ret == 0

def setup_iptables():
  """Setup iptables for this script"""
  if not ipt_chain_exists('nat', IPT_CHAIN):
    os.system("iptables -t nat -N {}".format(IPT_CHAIN))
    os.system("iptables -t nat -A PREROUTING "
      "-m addrtype --dst-type LOCAL -j {}".format(
      IPT_CHAIN))
  if not ipt_chain_exists('nat', IPT_MASQ_CHAIN):
    os.system("iptables -t nat -N {}".format(IPT_MASQ_CHAIN))
    os.system("iptables -t nat -A POSTROUTING -j {}".format(IPT_MASQ_CHAIN))

  if not ipt_chain_exists('filter', IPT_CHAIN):
    os.system("iptables -N {}".format(IPT_CHAIN))
    os.system("iptables -A FORWARD -j {}".format(
      IPT_CHAIN))

def get_docker_ip(name, interval=1, max_wait=30):
  """Get the docker IP

  :param name: The name of the docker running instance
  :param interval: How often to attempt to get the IP
  :param max_wait: How long to wait before failure
  :return: The IPAddress found otherwise None
  """
  global CONTAINER_IP
  # If the docker IP is already set then return that
  if CONTAINER_IP is not None:
    return CONTAINER_IP

  stime = time.time()
  cmd_list = ["/usr/bin/docker inspect"]
  cmd_list.append("-f '{{ .NetworkSettings.IPAddress }}'")
  cmd_list.append(name)
  cmd = " ".join(cmd_list)

  while time.time() - stime < max_wait:
    output = subprocess.check_output(cmd, shell=True)
    if "Error:" not in output:
      # Update the global CONTAINER_IP and return
      # the result
      CONTAINER_IP = output.strip()
      return CONTAINER_IP
    time.sleep(interval)

  print("Error: Failed to get IP for {}. Waited {}s".format(
    name, max_wait))
  return None

def iptables_run_rules(args, add):
  """Run the rules based on action

  :param args: Command line arguments
  :param add: If True then iptables commands will have -A otherwise -D
  """
  rules = []
  DOCKER_IP = get_docker_ip(args.name)
  if not DOCKER_IP:
    print("Failed to get docker IP for {}".format(
      args.name))
    return False

  action="-D"
  if add:
    action="-A"

  dest_ip="0.0.0.0/0"
  if args.bind:
    dest_ip="{}/32".format(args.bind)

  ports = {
    '5060': ['tcp', 'udp'],
    '5080': ['tcp', 'udp'],
    '8021': ['tcp'],
    '7443': ['tcp'],
    '60535:65535': ['udp'],
  }

  cmds = []
  for port, proto_list in ports.items():
    port_range = port.replace(':', '-')

    for proto in proto_list:
      # FILTER FORWARD
      cmd = (
        "iptables {action} {chain} -d {docker_ip} ! "
        "-i docker0 -o docker0 -p {proto} -m {proto} --dport {port} "
        "-j ACCEPT".format(
          action=action,
          chain=IPT_CHAIN,
          docker_ip=DOCKER_IP,
          port=port,
          proto=proto))
      cmds.append(cmd)

      # NAT PREROUTING DNAT
      cmd = (
        "iptables -t nat {action} {chain} -d {ip} ! "
        "-i docker0 -p {proto} -m {proto} --dport {port} "
        "-j DNAT --to-destination {docker_ip}:{port_range}".format(
          action=action,
          chain=IPT_CHAIN,
          ip=dest_ip,
          port=port,
          port_range=port_range,
          proto=proto,
          docker_ip=DOCKER_IP))
      cmds.append(cmd)

      # NAT POSTROUTING MASQUERADE
      cmd = (
        "iptables -t nat {action} {chain} "
        "-s {docker_ip} -d {docker_ip} "
        "-p {proto} -m {proto} --dport {port} "
        "-j MASQUERADE".format(
          action=action,
          chain=IPT_MASQ_CHAIN,
          port=port,
          proto=proto,
          docker_ip=DOCKER_IP))
      cmds.append(cmd)

  for cmd in cmds:
    print(cmd)
    os.system(cmd)
  return True

def iptables_add(args):
  """Add iptables rules

  :param args: Command line arguments
  :return: On success return True, otherwise False
  """
  return iptables_run_rules(args, True)

def iptables_delete(args):
  """Add iptables rules

  :param args: Command line arguments
  :return: On success return True, otherwise False
  """
  return iptables_run_rules(args, False)

def _ip_addr_action(addr, dev, add=True):
  """Add/remove an address

  :param addr: The IP Address to add
  :param dev: The device which should have the IP address
  :param add: If True will add, otherwise remove
  :return: True on success, False otherwise
  """
  action = "add"
  if not add:
    action = "del"

  cmd = "ip addr {} {}/32 dev {}".format(
    action,
    addr,
    dev)
  if os.system(cmd) != 0:
    print("Error: Failed to perform {}".format(cmd))
    return False
  return True

def ap_start(args):
  """Start the docker instance

  :param args: The command line arguments
  """
  if args.bind:
    if not args.dev:
      exit("Specifying a bind IP requires specifying the device to use")

  # Perform cleanup of the old state
  os.system("/usr/bin/docker stop {}".format(args.name))
  os.system("/usr/bin/docker rm {}".format(args.name))

  # Set the conf_str based on whether the freeswitch conf will be mapped
  conf_str = ""

  # Start docker
  cmd_list = []
  cmd_list.append("/usr/bin/docker run -d")
  cmd_list.append("--name {}".format(args.name))

  if args.path:
    cmd_list.append('-v {}:{}'.format(
      args.path,
      args.remote_path))

  cmd_list.append(args.container)
  cmd = ' '.join(cmd_list)
  print("Command: {}".format(cmd))
  ret = os.system(cmd)
  if ret != 0:
    print("Failed to start docker. ret: {} cmd: {}".format(
      ret, cmd))

  if args.bind and args.dev:
    if not _ip_addr_action(args.bind, args.dev):
      print("Failed to bind to {}:{}".format(args.bind, args.dev))
      ap_stop(args)
      sys.exit(2)

  if not iptables_add(args):
    print("Failed to write iptables rules. Stopping...")
    ap_stop(args)
    sys.exit(1)

  # Re-attach to the container
  os.system("/usr/bin/docker attach {}".format(args.name))

  ######
  # At this point we were told to stop
  ######

  # Stop the container - it should not be running but
  # lets double check
  _docker_stop(args.name)

  # Remove the rules
  iptables_delete(args)

  # Remove the address associated
  if args.bind and args.dev:
    _ip_addr_action(args.bind, args.dev, add=False)

def  _docker_stop(name):
  """Stop a docker container

  :param name: The docker to stop
  """
  os.system("/usr/bin/docker stop {}".format(name))

def ap_stop(args):
  """Stop the docker instance

  :param args: The command line arguments
  """
  _docker_stop(args.name)

def ap_cleanup(args):
  """This will cleanup the state

  :param args: The command line arguments
  """
  # Flush the iptables chains
  os.system("iptables -t nat -F {}".format(IPT_CHAIN))
  os.system("iptables -t nat -F {}".format(IPT_MASQ_CHAIN))
  os.system("iptables -F {}".format(IPT_CHAIN))

  # Stop the docker instances its running for the name specified
  os.system("docker stop {}".format(args.name))

  # If an address and dev is specified then attempt
  # to remove it
  if args.bind and args.dev:
    _ip_addr_action(args.bind, args.dev, add=False)

if __name__ == "__main__":
  # Must be root
  if os.getuid() != 0:
    exit("You need to have root privileges to run this script")

  def add_sp(sub_p, action, func=None, help=None):
    """Add an action to the main parser

    :param sub_p: The sub parser
    :param action: The action name
    :param func: The function to perform for this action
    :param help: The help to show for this action
    :rtype: The parser that is generated
    """
    p = sub_p.add_parser(action, help=help)
    if func:
      p.set_defaults(func=func)
    return p

  def _parser_add_common(parser):
    if not parser:
      exit("No parser specified")

    # Name to run
    parser.add_argument('-n', '--name',
      help='Name of the running container. Default: {}'.format(
        NAME),
      default=NAME)
    parser.add_argument('-c', '--container',
      help='Which base container to use. Default {}'.format(CONTAINER),
      default=CONTAINER)

    # Bind options
    parser.add_argument('-b', '--bind',
      help='Bind to a specific IP. Note: This will add/del the address')
    parser.add_argument('--dev',
      help='Which device the IP address belongs to')

    # MAP options
    parser.add_argument('-p', '--path',
      help='Local path to map to docker instance')
    parser.add_argument('-r', '--remote-path',
      help='Path on docker instance',
      default='/root/freeswitch')

  # Setup Iptables
  setup_iptables()

  parser = argparse.ArgumentParser(
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description = 'Docker freeSWITCH script')
  sub_p = parser.add_subparsers(title='Actions',
    help='%(prog)s <action> -h for more info')
  p_start = add_sp(sub_p, "start", func=ap_start,
    help="Start docker freeSWITCH")
  _parser_add_common(p_start)

  p_stop = add_sp(sub_p, "stop", func=ap_stop,
    help="Stop docker freeSWITCH")
  _parser_add_common(p_stop)

  p_cleanup = add_sp(sub_p, "cleanup", func=ap_cleanup,
    help="Cleanup the docker freeswitch state")
  _parser_add_common(p_cleanup)

  args = parser.parse_args()
  ARGS = args
  args.func(args)
