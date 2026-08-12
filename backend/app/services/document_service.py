import os
import shutil

from fastapi import UploadFile, HTTPException
from sqlalchemy.orm import Session

from app.models.document import Document
from app.models.patient import Patient

UPLOAD_FOLDER = "uploads/documents"

os.makedirs(UPLOAD_FOLDER, exist_ok=True)


def upload_document(
    db: Session,
    patient_id: int,
    title: str,
    file: UploadFile,
):
    patient = db.query(Patient).filter(
        Patient.id == patient_id
    ).first()

    if not patient:
        raise HTTPException(
            status_code=404,
            detail="Patient not found"
        )

    file_path = os.path.join(
        UPLOAD_FOLDER,
        file.filename,
    )

    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    document = Document(
    patient_id=patient_id,
    title=title,
    file_name=file.filename,
    file_path=f"http://10.0.2.2:8000/uploads/documents/{file.filename}",
)

    db.add(document)
    db.commit()
    db.refresh(document)

    return document


def get_patient_documents(
    db: Session,
    patient_id: int,
):
    return db.query(Document).filter(
        Document.patient_id == patient_id
    ).all()


def delete_document(
    db: Session,
    document_id: int,
):
    document = db.query(Document).filter(
        Document.id == document_id
    ).first()

    if not document:
        raise HTTPException(
            status_code=404,
            detail="Document not found"
        )

    if os.path.exists(document.file_path):
        os.remove(document.file_path)

    db.delete(document)
    db.commit()

    return {
        "message": "Document deleted"
    }