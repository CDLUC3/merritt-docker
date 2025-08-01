FROM public.ecr.aws/aws-observability/aws-for-fluent-bit

RUN yum -y update

COPY *.conf /fluent-bit/etc/

RUN cat /fluent-bit/etc/parsers.conf /fluent-bit/etc/parsers-customizations.conf > /fluent-bit/etc/parsers-merged.conf 