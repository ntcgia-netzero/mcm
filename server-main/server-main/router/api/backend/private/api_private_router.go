package private

import (
	"MCM/router/api/backend/private/user"
	"github.com/gin-gonic/gin"
)

func AddRoutes(r *gin.RouterGroup) {
	userRoute := r.Group("/user")
	user.AddRoutes(userRoute)
}
