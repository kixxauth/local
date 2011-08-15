echo 'testing amazon web services'
echo ''
echo 'checking CNAME record elb.fireworksproject.com'
curl -i http://elb.fireworksproject.com/
echo ''
echo 'checking AWS Elastic Load Balancer'
curl -i http://example-load-balancer-1657952632.us-east-1.elb.amazonaws.com
echo ''
echo 'checking appserver at ec2-50-19-56-180.compute-1.amazonaws.com'
curl -i http://ec2-50-19-56-180.compute-1.amazonaws.com
echo ''
echo 'checking appserver at ec2-174-129-134-159.compute-1.amazonaws.com'
curl -i http://ec2-174-129-134-159.compute-1.amazonaws.com
echo ''
echo 'checking appserver at ec2-75-101-170-239.compute-1.amazonaws.com'
curl -i http://ec2-75-101-170-239.compute-1.amazonaws.com
echo ''
echo 'checking appserver at ec2-50-19-185-171.compute-1.amazonaws.com'
curl -i http://ec2-50-19-185-171.compute-1.amazonaws.com
