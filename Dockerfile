#
# Copyright 2018 Apereo Foundation (AF) Licensed under the
# Educational Community License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may
# obtain a copy of the License at
#
#     http://opensource.org/licenses/ECL-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an "AS IS"
# BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing
# permissions and limitations under the License.
#

#
# Setup in two steps
#
# Step 1: Build the image
# $ docker build -f Dockerfile -t oae-ethercalc:latest .
# Step 2: Run the docker
# $ docker run -it --name=ethercalc --net=host oae-ethercalc:latest
#

FROM  node:10-alpine
LABEL Name=OAE-Ethercalc
LABEL Author=ApereoFoundation
LABEL Email=oae@apereo.org

#
# Install ethercalc
#
ENV ETHERCALC_PATH /opt/ethercalc

RUN apk --no-cache add curl git su-exec \
    && addgroup -S -g 1001 ethercalc \
    && adduser -S -u 1001 -G ethercalc -G node ethercalc

RUN cd /opt && git clone https://github.com/oaeproject/ethercalc.git

WORKDIR ${ETHERCALC_PATH}
RUN cd ${ETHERCALC_PATH} && npm install --silent
RUN npm install --silent --global pm2

RUN chown -R ethercalc:ethercalc ${ETHERCALC_PATH}
USER ethercalc

EXPOSE 8000
CMD ["sh", "-c", "REDIS_HOST=oae-redis REDIS_PORT=6379 RABBIT_HOST=oae-rabbitmq RABBIT_PORT=5672 RABBIT_EXCHANGE=oae-taskexchange pm2 start /opt/ethercalc/app.js && pm2 logs"]
