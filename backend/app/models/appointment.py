from sqlalchemy import Column
from sqlalchemy import DateTime
from sqlalchemy import ForeignKey
from sqlalchemy import Integer
from sqlalchemy import String
from sqlalchemy.sql import func

from app.database import Base


class Appointment(Base):
    __tablename__ = "appointments"

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    patient_id = Column(
        Integer,
        ForeignKey("patients.id"),
        nullable=False,
    )

    doctor_id = Column(
        Integer,
        ForeignKey("users.id"),
        nullable=False,
    )

    appointment_date = Column(
        DateTime,
        nullable=False,
    )

    reason = Column(
        String,
        nullable=False,
    )

    status = Column(
        String,
        default="Pending",
    )

    created_at = Column(
        DateTime,
        server_default=func.now(),
    )