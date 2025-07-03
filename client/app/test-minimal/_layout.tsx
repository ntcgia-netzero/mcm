import React, { useState, createContext } from "react";
import { Stack } from "expo-router";

export const AuthContext = createContext<{
    isLoggedIn: boolean;
    setIsLoggedIn: (v: boolean) => void;
}>({ isLoggedIn: false, setIsLoggedIn: () => { } });

export default function RootLayout() {
    const [isLoggedIn, setIsLoggedIn] = useState(false);

    return (
        <AuthContext.Provider value={{ isLoggedIn, setIsLoggedIn }}>
            <Stack
                screenOptions={{
                    headerShown: false,
                }}
            >
                {/* 自動根據檔案路徑處理 */}
            </Stack>
        </AuthContext.Provider>
    );
}
