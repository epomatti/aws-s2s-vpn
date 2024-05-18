#!/usr/bin/env bash

dnf check-update

dnf install -y nginx
systemctl start nginx.service
systemctl status nginx.service
systemctl enable nginx.service
