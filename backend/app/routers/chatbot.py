from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from app.core.config import settings
from app.services.chatbot_service import ask_chatbot


router = APIRouter(
    prefix="/chatbot",
    tags=["Chatbot"],
)


class ChatRequest(BaseModel):
    message: str


@router.post("/")
def chat(request: ChatRequest):

    if not settings.OPENROUTER_API_KEY:
        raise HTTPException(
            status_code=500,
            detail="OPENROUTER_API_KEY is missing",
        )

    try:
        return ask_chatbot(request.message)

    except Exception as e:
        print("Chatbot error:", str(e))

        raise HTTPException(
            status_code=500,
            detail="Failed to contact AI service",
        )