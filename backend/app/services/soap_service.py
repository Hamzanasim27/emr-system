import requests

from app.core.config import settings


URL = "https://openrouter.ai/api/v1/chat/completions"


def generate_soap_note(diagnosis: str, clinical_notes: str):

    prompt = f"""
You are an AI medical documentation assistant.

Generate a SOAP note from the consultation information below.

Your task is to create a useful clinical documentation draft.

IMPORTANT RULES:

1. SUBJECTIVE
- Extract the patient's symptoms, complaints, duration, history, and relevant information from the clinical notes.
- If symptoms are not explicitly documented, do not invent specific symptoms.
- You may clearly state that subjective information was not documented.

2. OBJECTIVE
- Extract any documented vital signs, examination findings, laboratory results,
  imaging results, or other objective information.
- Do not invent vital signs, examination findings, laboratory results, or imaging.
- If objective information is missing, state:
  "No objective findings were documented."

3. ASSESSMENT
- Use the diagnosis provided by the doctor.
- You may write a short clinical assessment based on the documented diagnosis and symptoms.
- Do not introduce a different diagnosis.

4. PLAN
- Generate a reasonable clinical plan based on the documented diagnosis and symptoms.
- The plan may include general management, monitoring, follow-up, and safety advice.
- Do not invent medications, dosages, laboratory tests, imaging, or procedures that were not documented.
- If a specific treatment is documented, include it.
- If no treatment is documented, provide a general recommendation appropriate for the documented condition and clearly make it a suggested plan for doctor review.

5. Do not use meaningless phrases such as:
- "Take care"
- "Okay"
- "Thanks"
- "Not provided in the consultation notes"
as a medical treatment plan.

6. Keep the SOAP note concise and professional.

7. This is an AI-generated draft for review by a qualified doctor.
Do not claim that the AI-generated plan is a confirmed medical order.

Return ONLY the SOAP note using exactly this format:

SUBJECTIVE:
...

OBJECTIVE:
...

ASSESSMENT:
...

PLAN:
...

Diagnosis:
{diagnosis}

Clinical Notes:
{clinical_notes}
"""

    headers = {
        "Authorization": f"Bearer {settings.OPENROUTER_API_KEY}",
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
                    "You are a medical documentation assistant. "
                    "Generate concise SOAP documentation drafts. "
                    "Never fabricate patient-specific clinical facts."
                ),
            },
            {
                "role": "user",
                "content": prompt,
            },
        ],
        "temperature": 0.4,
        "max_tokens": 600,
    }

    response = requests.post(
        URL,
        headers=headers,
        json=payload,
        timeout=60,
    )

    if response.status_code != 200:
        print("OpenRouter error:", response.status_code)
        print(response.text)
        raise Exception("OpenRouter API request failed")

    data = response.json()

    return data["choices"][0]["message"]["content"]