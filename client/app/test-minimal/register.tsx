import { useState } from "react";
import { View, Text, TextInput, TouchableOpacity, Alert } from "react-native";
import { router } from "expo-router";

export default function RegisterScreen() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const handleRegister = () => {
        Alert.alert("註冊成功", "請返回登入頁");
        router.back();
    };
    return (
        <View className="flex-1 justify-center bg-white px-6">
            <Text className="text-2xl font-bold mb-8 text-center">註冊帳號</Text>
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
            <TouchableOpacity className="bg-blue-600 rounded-xl py-3" onPress={handleRegister}>
                <Text className="text-white text-center font-bold text-base">註冊</Text>
            </TouchableOpacity>
        </View>
    );
}
