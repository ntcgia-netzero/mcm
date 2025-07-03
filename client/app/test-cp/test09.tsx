import { useState } from "react";
import { View, Text, TextInput, Pressable, SafeAreaView, KeyboardAvoidingView, Platform, ActivityIndicator, Alert } from "react-native";
import { router } from "expo-router";
import { useSafeAreaInsets } from "react-native-safe-area-context";

export default function LoginScreen() {
    const insets = useSafeAreaInsets();
    const [email, setEmail] = useState("");
    const [pwd, setPwd] = useState("");
    const [showPwd, setShowPwd] = useState(false);
    const [isLoading, setIsLoading] = useState(false);
    const [remember, setRemember] = useState(false);

    const handleLogin = async () => {
        if (!email.match(/^\S+@\S+\.\S+$/)) {
            Alert.alert("錯誤", "請輸入正確的 Email");
            return;
        }
        if (pwd.length < 6) {
            Alert.alert("錯誤", "密碼長度至少 6 位");
            return;
        }
        setIsLoading(true);
        try {
            setTimeout(() => {
                setIsLoading(false);
                router.replace("/main");
            }, 1000);
        } catch (e) {
            setIsLoading(false);
            Alert.alert("登入失敗", "請確認帳號密碼");
        }
    };

    return (
        <SafeAreaView className="flex-1 bg-white" style={{ paddingTop: insets.top, paddingBottom: insets.bottom }}>
            <KeyboardAvoidingView
                className="flex-1 justify-center items-center px-6"
                behavior={Platform.OS === "ios" ? "padding" : "height"}
            >
                {/* Logo 區塊 */}
                <Text className="text-3xl font-bold mb-10 text-black">登入 Login</Text>
                {/* 表單卡片 */}
                <View className="bg-white rounded-2xl shadow-2xl p-8 w-full max-w-[360px]">
                    {/* Email */}
                    <TextInput
                        className="border-b border-gray-200 py-3 mb-4 text-base"
                        placeholder="Email"
                        keyboardType="email-address"
                        autoCapitalize="none"
                        autoCorrect={false}
                        importantForAutofill="yes"
                        textContentType="username"
                        value={email}
                        onChangeText={setEmail}
                        accessibilityLabel="輸入 Email"
                        returnKeyType="next"
                    />
                    {/* 密碼 */}
                    <View className="flex-row items-center border-b border-gray-200">
                        <TextInput
                            className="flex-1 py-3 text-base"
                            placeholder="Password"
                            secureTextEntry={!showPwd}
                            autoCapitalize="none"
                            autoCorrect={false}
                            textContentType="password"
                            value={pwd}
                            onChangeText={setPwd}
                            accessibilityLabel="輸入密碼"
                            returnKeyType="done"
                        />
                        <Pressable
                            className="px-2"
                            onPress={() => setShowPwd((v) => !v)}
                            accessibilityLabel={showPwd ? "隱藏密碼" : "顯示密碼"}
                        >
                            <Text className="text-xs text-gray-500">{showPwd ? "隱藏" : "顯示"}</Text>
                        </Pressable>
                    </View>
                    {/* Remember Me & 忘記密碼 */}
                    <View className="flex-row items-center justify-between mt-4 mb-2">
                        <Pressable
                            className="flex-row items-center"
                            onPress={() => setRemember((v) => !v)}
                            accessibilityLabel="保持登入"
                        >
                            <View className={`w-5 h-5 mr-2 rounded border border-gray-300 items-center justify-center ${remember ? 'bg-black' : 'bg-white'}`}>
                                {remember && <View className="w-3 h-3 rounded bg-white" />}
                            </View>
                            <Text className="text-xs text-gray-700">保持登入</Text>
                        </Pressable>
                        <Pressable onPress={() => router.push("/forgot")} accessibilityLabel="忘記密碼">
                            <Text className="text-xs text-blue-500">忘記密碼？</Text>
                        </Pressable>
                    </View>
                    {/* 登入按鈕 */}
                    <Pressable
                        className={`mt-5 py-3 rounded-xl ${isLoading ? 'bg-gray-300' : 'bg-black'}`}
                        disabled={isLoading}
                        onPress={handleLogin}
                        accessibilityLabel="登入"
                    >
                        {isLoading ? (
                            <ActivityIndicator color="#fff" />
                        ) : (
                            <Text className="text-center text-white text-base font-semibold">登入</Text>
                        )}
                    </Pressable>
                </View>
                {/* 註冊、社群登入 */}
                <View className="flex-row justify-between mt-7 w-full max-w-[360px]">
                    <Pressable onPress={() => router.push("/register")}>
                        <Text className="text-xs text-gray-600 underline">註冊帳號</Text>
                    </Pressable>
                    {/* 可加上社群登入按鈕（Google、Apple等） */}
                </View>
            </KeyboardAvoidingView>
        </SafeAreaView>
    );
}
