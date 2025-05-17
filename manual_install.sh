
# install flux
flux install

flux create source git flux-system \
  --url=https://github.com/trongtruong2509/fleet-infra \
  --branch=adopt-test \
  --interval=1m 
