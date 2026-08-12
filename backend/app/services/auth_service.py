from sqlalchemy.orm import Session
from fastapi import HTTPException

from app.models.user import User
from app.models.patient import Patient
from app.schemas.user import RegisterSchema, LoginSchema
from app.core.security import hash_password, verify_password, create_access_token


def register_user(db: Session, data: RegisterSchema):
    existing = db.query(User).filter(User.email == data.email).first()

    if existing:
        raise HTTPException(
            status_code=400,
            detail="Email already exists"
        )

    user = User(
        full_name=data.full_name,
        email=data.email,
        password=hash_password(data.password),
        role=data.role
    )

    db.add(user)
    db.commit()
    db.refresh(user)

    return user


def login_user(db: Session, data: LoginSchema):
    print("Email received:", data.email)
    print("Password received:", data.password)

    user = db.query(User).filter(User.email == data.email).first()

    print("User:", user)
    if user:
        print("Stored Password:", user.password)

    if not user:
        raise HTTPException(
            status_code=401,
            detail="Invalid Email"
        )

    if not verify_password(data.password, user.password):
        raise HTTPException(
            status_code=401,
            detail="Invalid Password"
        )

    token = create_access_token(
        {
            "sub": str(user.id),
            "role": user.role
        }
    )

    patient = db.query(Patient).filter(
        Patient.user_id == user.id
    ).first()

    return {
        "access_token": token,
        "token_type": "bearer",
        "user": {
            "id": user.id,
            "full_name": user.full_name,
            "email": user.email,
            "role": user.role,
        },
        "patient_id": patient.id if patient else None,
    }