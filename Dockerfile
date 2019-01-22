FROM mono:5.12.0.226 AS build

ARG DONATION_LEVEL=0.05

COPY server /server
COPY hash_cn/libhash /libhash

 RUN set -ex && sed -ri "s/^(.*DonationLevel = )[0-9]\.[0-9]{2}/\1${DONATION_LEVEL}/" /server/Server/DevDonation.cs && \
	apt-get -qq update && \
	apt-get -qq install build-essential && \
	cd /libhash && \
	make && \
	cd /server && \
	msbuild Server.sln /p:Configuration=Release_Server /p:Platform="any CPU"

FROM mono:5.12.0.226

ARG POOL_ROOT=/opt/pool
RUN mkdir -p $POOL_ROOT

VOLUME "/opt"
WORKDIR  $POOL_ROOT

RUN set -ex \
 && apt-get -qq update \
 && apt-get install -qq cron openssl curl coreutils socat git


#COPY entrypoint.sh /entrypoint.sh
COPY --from=build /server/Server/bin/Release_Server/server.exe $POOL_ROOT
COPY --from=build /server/Server/bin/Release_Server/pools.json $POOL_ROOT
COPY --from=build /libhash/libhash.so $POOL_ROOT



#COPY SDK/miner_raw /var/www/html


#COPY entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh

expose 18181

ENTRYPOINT ["/usr/bin/mono"]

CMD ["server.exe"]
