# Certbot azure dns challenge with traefik and coolify

This guide explains how to use Certbot with the Azure DNS plugin to issue certificates for Traefik and Coolify.

---

## 1. Set Up Azure DNS API Credentials

Certbot requires access to Azure DNS to manage DNS records.

### Create a Service Principal in Azure

1. Open the Azure CLI or Portal.
2. Run the following command:

   ```bash
   az ad sp create-for-rbac --name "Certbot" --role "DNS Zone Contributor" --scope "/subscriptions/<your_subscription_id>/resourceGroups/<your_resource_group>/providers/Microsoft.Network/dnsZones/<your_dns_zone>"`
   ```

## 2. Install Certbot and Azure Plugin

Install Certbot and the Azure DNS plugin:

```bash
sudo apt purge -y certbot
sudo snap install --classic certbot
sudo snap install --channel=stable certbot-dns-azure
sudo snap set certbot trust-plugin-with-root=ok
sudo snap connect certbot:plugin certbot-dns-azure
```

## 3. Configure Azure Credentials for Certbot

1. Create a credentials file for Certbot:

   ```bash
   sudo mkdir -p /etc/letsencrypt
   sudo nano /etc/letsencrypt/azure_credentials.ini
   ```

2. add the following content to the file:

   See [azure_credentials.ini](azure_credentials.ini) for the configuration.

3. Secure the file:

   ```bash
   sudo chmod 600 /etc/letsencrypt/azure_credentials.ini
   ```

## 4. Issue a Certificate

```bash
sudo certbot certonly --dns-azure-credentials /etc/letsencrypt/azure_credentials.ini -d *.joranslingerland.com
```

## 5. Automate Certificate Renewal

Certbot includes automatic renewal. Verify the scheduled task:

```bash
sudo systemctl list-timers | grep certbot
```

To ensure DNS challenges work during renewal, Certbot reuses the configuration and credentials stored in /etc/letsencrypt/renewal/<your-domain>.conf.

## 6. Add deploy-hook to Renewal Configuration

```bash
nano /etc/letsencrypt/renewal-hooks/deploy/cert_copy.sh
```

See [cert_copy.sh](cert_copy.sh) for the script.

```bash
chmod +x /etc/letsencrypt/renewal-hooks/deploy/cert_copy.sh
```

## 7. Add certificates to traefik

```bash
nano /data/coolify/proxy/dynamic/certs.yml
```

See [certs.yml](certs.yml) for the configuration.

## 6. Test Renewal

Test the renewal process:

```bash
sudo certbot renew --dry-run
```
