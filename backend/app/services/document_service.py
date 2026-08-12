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

        logger.info("File saved successfully: %s", file_path)

        document = Document(
            patient_id=patient_id,
            title=title,
            file_name=file.filename,
            file_path=f"/uploads/documents/{file.filename}",
        )

        db.add(document)
        db.commit()
        db.refresh(document)

        logger.info("Document created: %s", document.id)

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