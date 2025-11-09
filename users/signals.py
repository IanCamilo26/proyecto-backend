# users/signals.py
from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import User
from django.conf import settings
import requests
import os
import logging

logger = logging.getLogger(__name__)

@receiver(post_save, sender=User)
def on_user_created(sender, instance, created, **kwargs):
    if not created:
        return
    
    notification_url = os.getenv("NOTIFICATION_URL") or getattr(settings, "NOTIFICATION_URL", None)
    
    if not notification_url:
        logger.warning("NOTIFICATION_URL not configured")
        return
    
    # Payload que coincide con NotifyPayload del notification-service
    payload = {
        "subject": f"Nuevo usuario: {instance.name}",
        "message": f"Se creó el usuario {instance.name} ({instance.email}, {instance.phone})",
        "email": instance.email  # ← IMPORTANTE: destinatario del correo
    }
    
    try:
        logger.info(f"Sending notification to {notification_url}")
        resp = requests.post(notification_url, json=payload, timeout=5)
        resp.raise_for_status()
        logger.info(f"Notification sent successfully, status: {resp.status_code}")
    except requests.exceptions.RequestException as e:
        logger.error(f"Failed to send notification: {str(e)}")
    except Exception as e:
        logger.error(f"Unexpected error sending notification: {str(e)}")