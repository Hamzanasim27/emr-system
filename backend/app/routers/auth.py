from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import get_db

from app.schemas.user import RegisterSchema
from app.schemas.user import LoginSchema

from app.services.auth_service import register_user
from app.services.auth_service import login_user
from app.schemas.auth import LoginRequest


router = APIRouter(
    prefix="/auth",
    tags=["Authentication"]
)


@router.post("/register")
def register(
    data: RegisterSchema,
    db: Session = Depends(get_db)
):
    return register_user(db, data)


@router.post("/login")
def login(
    data: LoginRequest,
    db: Session = Depends(get_db),
):
    return login_user(db, data)