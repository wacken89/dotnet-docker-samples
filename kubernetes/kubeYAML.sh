#!/bin/bash

cat <<EOF > aspnet.yaml
---
apiVersion: v1
kind: Service
metadata:
  name: aspnet
  namespace: aspnet
spec:
  selector:
    aspenv: dev
  ports:
  - name: web
    port: 80
    targetPort: 80
  type: ClusterIP
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: aspnet
  namespace: aspnet
  annotations:
   kubernetes.io/ingress.class: traefik
spec:
  rules:
  - host: $DOMAIN
    http:
      paths:
      - backend:
          serviceName: aspnet
          servicePort: web
---
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: aspnet
  namespace: aspnet
spec:
  replicas: 1
  template:
    metadata:
      labels:
        aspenv: dev
    spec:
      containers:
        - name: aspnetapp
          image: hub.workshop.kruschecloud.com/workshop/aspnet:$TAG
          ports:
            - containerPort: 80
EOF