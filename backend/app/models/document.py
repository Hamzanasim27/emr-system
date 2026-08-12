from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime

from app.database import Base


class Document(Base):
    __tablename__ = "documents"

    id = Column(Integer, primary_key=True, index=True)

    patient_id = Column(Integer, ForeignKey("patients.id"))

    title = Column(String, nullable=False)

    file_name = Column(String, nullable=False)

    file_path = Column(String, nullable=False)

    uploaded_at = Column(DateTime, default=datetime.utcnow)

    patient = relationship("Patient")