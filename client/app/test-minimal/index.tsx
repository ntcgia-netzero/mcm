import { useState } from "react";
import { View, Text, TextInput, TouchableOpacity } from "react-native";
import { router } from "expo-router";

export default function LoginScreen() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    // TODO: 實際驗證登入
    const handleLogin = () => {
        if (email && password) router.replace("/test-minimal/home");
    };
    return (
        <View className="flex-1 justify-center bg-white px-6">
            <Text className="text-2xl font-bold mb-8 text-center">綠能碳排資料輸入系統</Text>
            <TextInput
                className="border border-gray-300 rounded-xl px-4 py-3 mb-4 bg-gray-50"
                placeholder="Email"
                autoCapitalize="none"
                value={email}
                onChangeText={setEmail}
            />
            <TextInput
                className="border border-gray-300 rounded-xl px-4 py-3 mb-4 bg-gray-50"
                placeholder="Password"
                secureTextEntry
                value={password}
                onChangeText={setPassword}
            />
            <TouchableOpacity className="bg-blue-600 rounded-xl py-3" onPress={handleLogin}>
                <Text className="text-white text-center font-bold text-base">登入</Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={() => router.push("./register")}>
                <Text className="text-blue-600 text-center mt-6">沒有帳號？註冊</Text>
            </TouchableOpacity>
        </View>
    );
}
