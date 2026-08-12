from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.sql import func

from app.database import Base


class Consultation(Base):
    __tablename__ = "consultations"

    id = Column(Integer, primary_key=True, index=True)

    patient_id = Column(Integer, ForeignKey("patients.id"))

    doctor_id = Column(Integer, ForeignKey("users.id"))

    diagnosis = Column(String, nullable=False)

    clinical_notes = Column(String, nullable=False)

    created_at = Column(DateTime(timezone=True), server_default=func.now())