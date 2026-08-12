import requests

from app.core.config import settings


URL = "https://openrouter.ai/api/v1/chat/completions"


def ask_chatbot(message: str):

    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "Content-Type": "application/json",
        "HTTP-Referer": "http://localhost",
        "X-Title": "EMR System",
    }

    payload = {
        "model": "openai/gpt-4.1-mini",
        "messages": [
            {
                "role": "system",
                "content": (
                    "You are an AI Health Assistant for an Electronic Medical "
                    "Record system. "
                    "Give only general medical information. "
                    "Do not diagnose diseases. "
                    "Always advise consulting a qualified doctor for persistent "
                    "or serious symptoms. "
                    "Keep answers short, clear, and easy to understand."
                ),
            },
            {
                "role": "user",
                "content": message,
            },
        ],
        "temperature": 0.5,
        "max_tokens": 300,
    }

    response = requests.post(
        URL,
        headers=headers,
        json=payload,
    )

    if response.status_code != 200:
        return {
            "reply": "Sorry, I couldn't contact the AI service."
        }

    data = response.json()

    return {
        "reply": data["choices"][0]["message"]["content"]
    }