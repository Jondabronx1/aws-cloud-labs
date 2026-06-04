from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.database import RDS
from diagrams.aws.network import (ALB, VPCElasticNetworkInterface, VPC, InternetGateway, NATGateway,
                                  PrivateSubnet, PublicSubnet, RouteTable)
from diagrams.generic.network import Firewall
from diagrams.onprem.client import User

# global variables thatcontrolled spacing and alignment
GRAP_ATTR = {
    "rankdir": "LR",
    "compound": "true",
    "nodesep": "1.2",
    "ranksep": "1.5",
    "splines": "ortho"

}

# intiliaze a left- right diagram for multi-tier aws architecture
with Diagram("Multi-tier-AWS Architecture(Terraform)", show=True, graph_attr=GRAP_ATTR):

    # creats my internet user
    user = User("Internet user")

    # inside my vpc
    with Cluster("VPC-multi-tier-app"):
        igw = InternetGateway("Internet Gateway")

        # inside public tier
        with Cluster("Public Subnets(AZ-A & AZ-B)"):

            # route table for public facing resources(web server)
            # directs all non local traffic to internet gateway
            public_rt = RouteTable(
                label="Public Route Table\n0.0.0.0/0 -> IGW")

            # entry point for all external web traffic
            # Inbound: Open to world on port 80 (HTTP)
            # -Outbound: Unrestricted to allow forwarding to internal subnets
            alb_sg = Firewall(
                "alb_sg\nInbound: HTTP 80 from Internet\nOutbound: All")

            alb = ALB("Application load Balancer")

            with Cluster("Target Group"):
                tg = Cluster("Target Group\nHTTP :80")

            eip = VPCElasticNetworkInterface("Elastic IP")

            nat = NATGateway("NAT Gateway")

        # inside the private tier
        with Cluster("Private Subnets"):

            # directs all non local traffic to NAT gateway
            private_rt = RouteTable(
                label="Private Route Table\n0.0.0.0/0 -> NAT")

            # create security group for ec2s
            app_sg = Firewall(
                "app_sg\nInbound: 80 frm alb_sg\nssh 22 from my IP")

            # add my instances inside the private subnet
            app1 = EC2("EC2 - AZ-A")
            app2 = EC2("EC2 - AZ-B")

        # inside the database tier
        with Cluster("Private DB subnets (Multi-AZ)"):

            # create security group for database
            db_sg = Firewall("db_sg\nInbound: from 5432 from app_sg")

            db = RDS("PostgressSQL RDS\nMulti-AZ Enabled")

    # Flow
    user >> Edge(label="HTTP") >> igw
    igw >> alb
    alb >> app1
    alb >> app2

    app1 >> Edge(label="5432") >> db
    app2 >> Edge(label="5432") >> db

    app1 >> private_rt >> nat >> igw
    app2 >> private_rt >> nat
    eip >> nat
