go_image := golang:1.21.3-alpine

default: builder final
	
builder:
	docker pull ${go_image}
	docker build -t dsbferris/traefik-crowdsec-bouncer:builder -f ./stage1.Dockerfile .

final:
	docker build -t dsbferris/traefik-crowdsec-bouncer:latest -f ./stage2.Dockerfile .

clean:
	docker image rm dsbferris/traefik-crowdsec-bouncer:builder dsbferris/traefik-crowdsec-bouncer:latest
