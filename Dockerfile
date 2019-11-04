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

ENV ETHERCALC_PATH /opt/ethercalc
ENV NODE_ENV production
ENV REDIS_HOST oae-redis
ENV REDIS_PORT 6379

# Create ethercalc user
RUN apk --no-cache add curl git su-exec \
    && addgroup -S -g 1001 ethercalc \
    && adduser -S -u 1001 -G ethercalc -G node ethercalc

# Install ethercalc
RUN git clone https://github.com/oaeproject/ethercalc.git ${ETHERCALC_PATH}

WORKDIR ${ETHERCALC_PATH}
RUN npm install --silent
RUN npm install --global pm2

RUN chown -R ethercalc:ethercalc .
USER ethercalc
EXPOSE 8000


CMD ["sh", "-c", "pm2 start --restart-delay=3000 /opt/ethercalc/app.js && pm2 logs"]
