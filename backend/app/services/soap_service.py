import requests

from app.config import settings


OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"


def generate_soap_note(diagnosis: str, clinical_notes: str):

    prompt = f"""
You are a medical documentation assistant helping a doctor prepare a SOAP note.

Create a professional SOAP note using ONLY the information provided below.

DIAGNOSIS:
{diagnosis}

CLINICAL NOTES:
{clinical_notes}

Generate exactly these four sections:

SUBJECTIVE:
Include patient-reported symptoms, complaints, history, duration, and relevant subjective information if present.

OBJECTIVE:
Include physical examination findings, vital signs, laboratory results, imaging results, and other objective findings if present.

ASSESSMENT:
Summarize the documented diagnosis and clinical assessment.

PLAN:
Include treatment, medications, investigations, follow-up, and medical recommendations ONLY if they are explicitly documented.

IMPORTANT RULES:
1. Never invent medical information.
2. Never invent symptoms, vital signs, examination findings, test results, medications, or treatment.
3. Do not create a new diagnosis.
4. Do not interpret casual phrases as medical instructions.
5. Phrases such as "take care", "okay", "thanks", or other conversational text are NOT a medical treatment plan.
6. If there is no actual medical plan, write:
   "Not provided in the consultation notes."
7. If information for Subjective or Objective is missing, write:
   "Not provided in the consultation notes."
8. The diagnosis can be used in the Assessment section because it is explicitly provided.
9. The generated SOAP note is a draft and must be reviewed by the doctor.

Return ONLY:

SUBJECTIVE:
...

OBJECTIVE:
...

ASSESSMENT:
...

PLAN:
...
"""

    response = requests.post(
        OPENROUTER_URL,
        headers={
            "Authorization": f"Bearer {settings.OPENROUTER_API_KEY}",
            "Content-Type": "application/json",
        },
        json={
            "model": "openai/gpt-4o-mini",
            "messages": [
                {
                    "role": "user",
                    "content": prompt,
                }
            ],
            "temperature": 0.2,
        },
        timeout=60,
    )

    response.raise_for_status()

    data = response.json()

    return data["choices"][0]["message"]["content"]