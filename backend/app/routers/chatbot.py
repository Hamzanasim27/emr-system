import os

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from langchain_openrouter import ChatOpenRouter

router = APIRouter(
    prefix="/chatbot",
    tags=["Chatbot"],
)


class ChatRequest(BaseModel):
    message: str


@router.post("/")
def chat(request: ChatRequest):

    api_key = os.getenv("OPENROUTER_API_KEY")

    if not api_key:
        raise HTTPException(
            status_code=500,
            detail="OPENROUTER_API_KEY is missing",
        )

    try:
        llm = ChatOpenRouter(
    model="openai/gpt-4o-mini",
    api_key=api_key,
    temperature=0.3,
    max_tokens=500,
)

        response = llm.invoke(request.message)

        return {
            "reply": response.content
        }

    except Exception as e:
        print("Chatbot error:", str(e))

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )