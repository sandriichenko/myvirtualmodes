#!/usr/bin/python

from __future__ import print_function

import argparse
import os
import sys
import yaml

def _merge_items(a, b, path=None):
    """Merge b into a"""
    if path is None: path = []
    for key in b:
        if key in a:
            if isinstance(a[key], dict) and isinstance(b[key], dict):
                _merge_items(a[key], b[key], path + [str(key)])
            elif a[key] == b[key]:
                pass # same leaf value
            else:
                raise Exception('Conflict at %s' % '.'.join(path + [str(key)]))
        else:
            a[key] = b[key]
    return a

def repo_add(content, name, source, pin_priority=None):
  """Adds repo dict to provided content"""
  t = {}
  r = {name: {'architectures': 'amd64',
              'source': source}}
  if pin_priority:
      r[name]['pin'] = [{'package': '*',
                         'priority': pin_priority,
                         'pin': 'release o=Ubuntu'}]
  t['parameters'] = {'linux': {'system': {'repo': r}}}
  _merge_items(content, t)

def main():
    parser = argparse.ArgumentParser(description='Update reclass model for specific node')
    parser.add_argument('--node',
                        type=str,
                        help='FQDN of the node to update.')
    parser.add_argument('--node-path',
                        type=str,
                        default='/srv/salt/reclass/nodes/_generated',
                        help='Path to directory with the nodes.')
    subparsers = parser.add_subparsers()

   
    # create the parser for the "add" command
    parser_add = subparsers.add_parser('repo_add', help='Add a new repo.')
    parser_add.set_defaults(command='repo_add')
    parser_add.add_argument('--repo-name',
                            type=str,
                            required=True,
                            help='The name of the repo to add.')
    parser_add.add_argument('--source',
                            type=str,
                            required=True,
                            help='The source link of the repo. For example: '
                                 'deb http://my.repo.com/xenial ocata main')
    parser_add.add_argument('--priority',
                            type=int,
                            help='The pin priority of the repo.')
    args = parser.parse_args()
    
    if args.node:
        node_files = ['%s/%s.yml' % (args.node_path, args.node)]
    else:
        
        node_files = ['%s/%s' % (args.node_path, f) for f in os.listdir(args.node_path) if f.endswith('.yml')]

    # check we can read the file
    for node_file in node_files:
        node_name = os.path.basename(node_file)[:-4]
        if not os.access(node_file, os.W_OK):
            print("Can not write to nodes file %s" % node_file, file=sys.stderr)
            sys.exit(1)

        try:
            content = {}
            with open(node_file) as f:
                content = yaml.load(f)

            if args.command == 'repo_add':
                print("Adding repo to the node: %s" % node_name)
                repo_add(content, args.repo_name, args.source, args.priority)

            with open(node_file, "w") as f:
                yaml.dump(content, f, default_flow_style=False)
            print("Node: %s has been updated successfully." % node_name)

        except Exception as e:
            print(e, file=sys.stderr)
            sys.exit(1)

if __name__ == '__main__':
    main()
