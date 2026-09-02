import os

from langchain_openrouter import ChatOpenRouter


class LangChainService:

    def __init__(self):
        api_key = os.getenv("OPENROUTER_API_KEY")

        if not api_key:
            raise RuntimeError(
                "OPENROUTER_API_KEY is not configured"
            )

        self.model = ChatOpenRouter(
            model="openai/gpt-4o-mini",
            temperature=0.2,
            max_tokens=500,
            max_retries=2,
        )

    def ask(self, message: str) -> str:

        response = self.model.invoke(
            [
                (
                    "system",
                    """
You are an AI health assistant inside an Electronic
Medical Record (EMR) system.

Give general health information only.

Do not diagnose diseases.

Do not prescribe medication.

If the user describes an emergency or severe symptoms,
advise them to seek immediate professional medical care.

Keep answers clear and concise.
""",
                ),
                ("human", message),
            ]
        )

        return response.content