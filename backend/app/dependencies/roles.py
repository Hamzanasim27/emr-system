from fastapi import Depends, HTTPException

from app.dependencies.auth import get_current_user


def require_role(*roles):

    def checker(current=Depends(get_current_user)):

        if current.role not in roles:
            raise HTTPException(
                status_code=403,
                detail="Permission Denied"
            )

        return current

    return checker