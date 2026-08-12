from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from app.database import Base, engine

from app.routers.auth import router as auth_router
from app.routers.patient import router as patient_router
from app.routers import (
    document,
    doctor,
    consultation,
    prescription,
    appointment,
    clinical_note,
    doctor_availability,
    chatbot,
)

from app.models.doctor_availability import DoctorAvailability


Base.metadata.create_all(bind=engine)


app = FastAPI(
    title="Electronic Medical Record API",
)


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
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