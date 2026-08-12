from fastapi import APIRouter, Depends, File, Form, UploadFile, HTTPException
from sqlalchemy.orm import Session

from app.database import get_db
from app.dependencies.auth import get_current_user
from app.models.patient import Patient
from app.models.user import User
from app.services.document_service import (
    upload_document,
    get_patient_documents,
    delete_document,
)

router = APIRouter(
    prefix="/documents",
    tags=["Documents"],
)


@router.post("/")
def upload(
    title: str = Form(...),
    file: UploadFile = File(...),
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db),
):
    patient = db.query(Patient).filter(
        Patient.user_id == current_user.id
    ).first()

    return upload_document(
        db,
        patient.id,
        title,
        file,
    )


@router.get("/me")
def my_documents(
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db),
):
    patient = db.query(Patient).filter(
        Patient.user_id == current_user.id
    ).first()

    return get_patient_documents(
        db,
        patient.id,
    )


@router.delete("/{document_id}")
def remove(
    document_id: int,
    db: Session = Depends(get_db),
):
    return delete_document(
        db,
        document_id,
    )
@router.get("/{patient_id}")
def patient_documents(
    patient_id: int,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    return get_patient_documents(
        db,
        patient_id,
    )