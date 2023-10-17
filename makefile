
builder_name := dsbferris/traefik-crowdsec-bouncer-builder:v0.5.3
final_name := dsbferris/traefik-crowdsec-bouncer:v0.5.3
go_image := golang:1.21.3-alpine

default: builder final
	
builder:
	docker pull ${go_image}
	docker build -t ${builder_name} -f ./stage1.Dockerfile .

final:
	docker build -t ${final_name} -f ./stage2.Dockerfile .

clean:
	docker image rm ${builder_name} ${final_name}
