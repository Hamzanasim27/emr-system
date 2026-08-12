from fastapi import APIRouter
from pydantic import BaseModel

from app.services.chatbot_service import ask_chatbot


router = APIRouter(
    prefix="/chatbot",
    tags=["Chatbot"],
)


class ChatRequest(BaseModel):
    message: str


@router.post("/")
def chat(request: ChatRequest):
    return ask_chatbot(
        request.message,
    )