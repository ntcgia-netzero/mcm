package util

// 提供 JWT 驗證與密碼雜湊等工具函式

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
	"strings"
	"time"
)

// GenerateJWTToken 根據使用者 ID 產生 JWT token
func GenerateJWTToken(userId string) (string, error) {
	secretKey := []byte("yiijwu_is_best!") // 加密用的密鑰

	token := jwt.New(jwt.SigningMethodHS256)

	claims := token.Claims.(jwt.MapClaims)
	claims["userId"] = userId
	claims["exp"] = time.Now().Add(time.Hour * 24).Unix()

	tokenString, err := token.SignedString(secretKey)
	if err != nil {
		return "", err
	}

	return tokenString, nil
}

// AuthMiddleware 驗證 JWT 是否有效的中介層
func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		secretKey := []byte("yiijwu_is_best!")

		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			FailedResponse(c, -1, "Authorization header is required")
			c.Abort()
			return
		}

		bearerToken := strings.Split(authHeader, " ")
		if len(bearerToken) != 2 {
			FailedResponse(c, -1, "Invalid token format")
			c.Abort()
			return
		}

		tokenString := bearerToken[1]

		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
			}
			return secretKey, nil
		})

		if err != nil {
			FailedResponse(c, -1, err.Error())
			c.Abort()
			return
		}

		if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
			c.Set("userId", claims["userId"])
			c.Next()
		} else {
			FailedResponse(c, -1, "Invalid token")
			c.Abort()
			return
		}
	}
}

// CheckUserId 檢查上下文中的 userId 是否與參數一致
func CheckUserId(c *gin.Context, userId string) bool {
	if c.GetString("userId") != userId {
		FailedResponse(c, -1, "UserId not match")
		return false
	}

	return true
}

// HashPassword 將密碼雜湊後回傳
func HashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	return string(bytes), err
}

// CheckPasswordHash 驗證密碼與雜湊值是否相符
func CheckPasswordHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}
