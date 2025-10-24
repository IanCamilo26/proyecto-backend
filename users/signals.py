from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import User
from django.conf import settings
import requests
import os

@receiver(post_save, sender=User)
def on_user_created(sender, instance, created, **kwargs):
    if not created:
        return

    subject = f"Nuevo usuario: {instance.name}"
    message = f"Se creó el usuario {instance.name} ({instance.email}, {instance.phone})"
    admin_email = os.getenv("ADMIN_EMAIL") or getattr(settings, "ADMIN_EMAIL", None)

    notification_url = os.getenv("NOTIFICATION_URL") or getattr(settings, "NOTIFICATION_URL", None)
    if not notification_url:
        print("Notification fallback — no NOTIFICATION_URL configured.")
        return

    payload = {
        "subject": subject,
        "message": message,
        "email": admin_email or instance.email
    }

    try:
        resp = requests.post(notification_url, json=payload, timeout=5)
        resp.raise_for_status()
        print("Notification sent, status:", resp.status_code)
    except Exception as e:
        print("Failed to send notification:", str(e))