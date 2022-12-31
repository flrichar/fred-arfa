# fred-arfa
freds arfa -- aws reference architecture

 This is terraform code for a reference architecture I've used in my own notes and labs for ages.

 The goals behind it were as follows:

 - terraform 0.12+, tested with 0.12.x, 0.13.x, 0.14.x
 - AWS cloud resources that cost zero dollars when no instances and no volumes are present
 - remove unnecessary stuff like NAT gws, xLBs, VPN, storage
 - limit access to only trusted public (ipv4/ipv6) nets, and other private trust-nets originating behind secure protocols like VPN/SSH/TLS
 - if a nat gw is desired, spin up a small linux distro like vyos (can also handle vpn traffic)
 - 1x internal and 1x external subnets, in two different AZs
 - dual stack ipv4 & ipv6, the v6-internal subnet uses eigw for egress-only
 - global tags and global naming convention, the project and pieces should be obvious by name
 - group terraform files by their roles, and optional components (ssh-key files, extra tags, dhcp options)
 - keep env vars separate, then symlink terraform.tfvars for maximum laziness
 - ability to run this arfa (AWS ReFerence Archictecture) in different regions with identical config

A big thanks to my pals -- you know who you are -- I took a lot of your tf ideas and mashed them together with mine. If there's a proper awesome way to send attribution let me know.

This is nowhere near perfect. I want to make the access rules for trust-nets a variable, and perhaps a module for the subnets.  Right now there's a weird catch 22 where terraform can't count subnets if they're not created yet.  One can always get around this by using terraform -target=aws_vpc.main ... in other words, create the VPC first then continue.

Because I use this in my labs, tons of subnets were not necessary.  As small as necessary, with only two.

Other ideas? Add other no-cost resources (looking at you, peering connections).

Another idea I had was to make the tf flexible, you may see some ignore statements commented out.  I actually wrote this backwards by having the cloud resources built first, then imported everything.  An idea occurred to me that some resources without a lot of dependencies (ie ipv6-subnets) could be optionally imported, or created outside of terraform, hence the "ignore importing v6 cidr" type of comments.
