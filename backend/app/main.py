from fastapi import FastAPI

from app.database import Base
from app.database import engine

from app.routers.auth import router as auth_router
from app.routers.patient import router as patient_router
from app.routers import document
from fastapi.staticfiles import StaticFiles
from app.routers import doctor
from app.routers import consultation
from app.routers import prescription
from app.routers import appointment
from app.routers import clinical_note
from app.models.doctor_availability import DoctorAvailability
from app.routers import doctor_availability
from app.routers import chatbot

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Electronic Medical Record API"
)
app.mount(
    "/uploads",
    StaticFiles(directory="uploads"),
    name="uploads",
)

app.include_router(auth_router)
app.include_router(patient_router)
app.include_router(document.router)
app.include_router(consultation.router)
app.include_router(doctor.router)
app.include_router(prescription.router)
app.include_router(clinical_note.router)
app.include_router(appointment.router)
app.include_router(doctor_availability.router)
app.include_router(chatbot.router)