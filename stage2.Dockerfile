FROM dsbferris/traefik-crowdsec-bouncer-builder:v0.5.3 as build

WORKDIR /go/src/app
COPY ./ ./

# Sanity check
# Get all dependencies
RUN go mod download

# CGO_ENABLE=0 enforces the use of go's native implementation.
# With this we avoid having a dynamically linked executable
# that would not work in our standalone container down below.

# Build the healthchecker executable
RUN CGO_ENABLED=0 go build \
    -installsuffix 'static' \
    -o /healthchecker ./healthcheck/healthchecker.go 

# Build the bouncer executable
RUN CGO_ENABLED=0 go build \
    -installsuffix 'static' \
    -o /app .
 
#####################################
# STAGE 2: build the container to run
FROM gcr.io/distroless/static AS final
 
LABEL maintainer="dsbferris"

# Run as a non root user.
USER nonroot:nonroot
 
# copy compiled healthchecker
COPY --from=build --chown=nonroot:nonroot /healthchecker /healthchecker

# Using custom health checker
HEALTHCHECK --interval=10s --timeout=5s --retries=2\
  CMD ["/healthchecker"]
 
# copy compiled app
COPY --from=build --chown=nonroot:nonroot /app /app
# run binary; use vector form
ENTRYPOINT ["/app"]