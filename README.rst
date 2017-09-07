=======================
MCP Virtual Labs Models
=======================

Virtual reclass models for MCP based deployments for Dev & QA purposes.

Features implemented are expected to be backported to:
- cookiecutter repository
- system level reclass
- formula default metadata


Available deployments
=====================

AAA/Identity
--------------------

Model to develop and verify AAA/Identity integrations as separate product

Deployment:
* 1 config node
* 3 identity node (idm/idp)
* 2 proxy node

Clusters:
* aaa-ha-freeipa

Contacts: Petr Michalec, Adam Hecko, Florian S.

MCP DriveTrain
---------------------------------------

Clusters:
* model-manager
* drivetrain-ha
* drivetrain-ha-clusters

MCP OpenContrail (Openstack Mitaka)
---------------------------------------

Deployment:
* 1 config node
* 3 control nodes
* 2 compute nodes
* 1 monitor node
* 1 meter node
* 1 log node

Clusters:
* os-aio-contrail
* os-aio-ovs
* os-ha-contrail
* os-ha-contrail-40
* os-ha-ovs
* os-ha-ovs-syndic
* virtual-mcp05-dvr
* virtual-mcp05-ovs
* virtual-mcp10-contrail
* virtual-mcp10-dvr
* virtual-mcp10-ovs
* virtual-mcp11-aio
* virtual-mcp11-contrail
* virtual-mcp11-contrail-nfv
* virtual-mcp11-dvr
* virtual-mcp11-k8s-calico
* virtual-mcp11-k8s-calico-dyn
* virtual-mcp11-k8s-calico-minimal
* virtual-mcp11-k8s-contrail
* virtual-mcp11-ovs
* virtual-mcp11-ovs-dpdk
* virtual-mcp11-ovs-ironic
* virtual-mcp-ocata-cicd
* virtual-mcp-ocata-dvr
* virtual-mcp-ocata-ovs

MCP Kunbernetes
---------------

Deployment:
* 1 config node
* 3 control nodes
* 2 compute nodes

Clusters:
* k8s-aio-calico
* k8s-aio-contrail
* k8s-ha-calico
* k8s-ha-calico-syndic
* k8s-ha-contrail

Stacklight
----------

Clusters:
* sl-k8s-calico
* sl-k8s-contrail
* sl-os-contrail
* sl-os-ovs

Ceph
--------

Clusters:
* ceph-ha


Model validation
================

Models are validated on each commit with latest system-level reclass.

Models can be validated locally in docker instance with test-kitchen. Resources:
* https://github.com/salt-formulas/salt-formulas/tree/master/deploy/model
* https://salt-formulas.readthedocs.io/en/latest/develop/testing-formulas.html#requirements

Examples:
.. code-block:: shell

  ➜  mcp-virtual-lab git:(master) ✗ kitchen list
  Instance                                  Driver  Provisioner  Verifier  Transport  Last Action    Last Error
  cluster-aaa-ha-freeipa                    Docker  Shell        Busser    Ssh        Converged      <None>
  cluster-ceph-ha                           Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-drivetrain-ha                     Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-drivetrain-ha-clusters            Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-k8s-aio-calico                    Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-k8s-aio-contrail                  Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-k8s-ha-calico                     Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-k8s-ha-calico-syndic              Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-k8s-ha-contrail                   Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-model-manager                     Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-os-aio-contrail                   Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-os-aio-ovs                        Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-os-ha-contrail                    Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-os-ha-contrail-40                 Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-os-ha-ovs                         Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-os-ha-ovs-syndic                  Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-sl-k8s-calico                     Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-sl-k8s-contrail                   Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-sl-os-contrail                    Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-sl-os-ovs                         Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp05-dvr                 Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp05-ovs                 Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp10-contrail            Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp10-dvr                 Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp10-ovs                 Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp11-aio                 Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp11-contrail            Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp11-contrail-nfv        Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp11-dvr                 Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp11-k8s-calico          Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp11-k8s-calico-dyn      Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp11-k8s-calico-minimal  Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp11-k8s-contrail        Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp11-ovs                 Docker  Shell        Busser    Ssh        Converged      <None>
  cluster-virtual-mcp11-ovs-dpdk            Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp11-ovs-ironic          Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp-ocata-cicd            Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp-ocata-dvr             Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-virtual-mcp-ocata-ovs             Docker  Shell        Busser    Ssh        <Not Created>  <None>

.. code-block:: shell

  ➜  kitchen converge aaa-ha-freeipa


