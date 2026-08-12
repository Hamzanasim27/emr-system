import os
import shutil
import logging

from fastapi import UploadFile, HTTPException
from sqlalchemy.orm import Session

from app.models.document import Document
from app.models.patient import Patient


logger = logging.getLogger(__name__)

UPLOAD_FOLDER = "uploads/documents"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)


def upload_document(
    db: Session,
    patient_id: int,
    title: str,
    file: UploadFile,
):
    try:
        patient = db.query(Patient).filter(
            Patient.id == patient_id
        ).first()

        if not patient:
            raise HTTPException(
                status_code=404,
                detail="Patient not found",
            )

        if not file.filename:
            raise HTTPException(
                status_code=400,
                detail="No filename provided",
            )

        file_path = os.path.join(
            UPLOAD_FOLDER,
            file.filename,
        )

        logger.info("Saving uploaded file to: %s", file_path)

        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        document = Document(
            patient_id=patient_id,
            title=title,
            file_name=file.filename,
            file_path=f"/uploads/documents/{file.filename}",
        )

        db.add(document)
        db.commit()
        db.refresh(document)

        return document

    except HTTPException:
        raise

    except Exception as e:
        db.rollback()
        logger.exception("DOCUMENT UPLOAD FAILED")

        raise HTTPException(
            status_code=500,
            detail=f"Document upload failed: {str(e)}",
        )


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
            detail="Document not found",
        )

    actual_file_path = os.path.join(
        UPLOAD_FOLDER,
        document.file_name,
    )

    if os.path.exists(actual_file_path):
        os.remove(actual_file_path)

    db.delete(document)
    db.commit()

    return {
        "message": "Document deleted",
    }