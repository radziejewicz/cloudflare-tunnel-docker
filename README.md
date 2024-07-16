# Cloudflare Tunel for ARM64 devices

Cloudflared docker image for Raspberry Pi with quic support.


If you have an error: 
```
ERR Failed to create new quic connection error="failed to dial to edge with quic: INTERNAL_ERROR (local): tls: CurvePreferences includes unsupported curve" connIndex=0 event=0 ip=x.x.x.x
```


Use this image.


Documentation: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/

## How to run

Copy the .env.dist file and set the token:

```bash
cp .env.dist .env
```