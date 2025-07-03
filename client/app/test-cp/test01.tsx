import React, { useState } from 'react'
import {
    View,
    Text,
    TextInput,
    Pressable,
    Alert,
    ActivityIndicator,
    ScrollView,
} from 'react-native'

export default function Login() {
    const [account, setAccount] = useState('')
    const [password, setPassword] = useState('')
    const [accountError, setAccountError] = useState<string | null>(null)
    const [passwordError, setPasswordError] = useState<string | null>(null)
    const [loading, setLoading] = useState(false)

    const checkForm = () => {
        if (!account.trim()) {
            setAccountError('帳號不可為空')
            setLoading(false)
            return false
        }

        if (!password.trim()) {
            setPasswordError('密碼不可為空')
            setLoading(false)
            return false
        }

        return true
    }

    const login = () => {
        setLoading(true)
        setAccountError(null)
        setPasswordError(null)

        if (!checkForm()) return

        setTimeout(() => {
            setLoading(false)
            Alert.alert('Login', 'Login pressed')
        }, 1000)
    }

    return (
        <ScrollView className="flex-1 bg-white" contentContainerStyle={{ flexGrow: 1 }}>


            <View className="w-full px-10 items-center">
                <View className="w-full mt-10">
                    <Text className="text-base font-semibold">帳號</Text>
                    <TextInput
                        className="h-10 bg-gray-200 rounded-lg px-3 mt-2"
                        value={account}
                        onChangeText={setAccount}
                    />
                    {accountError && (
                        <Text className="text-red-500 mt-1">{accountError}</Text>
                    )}
                </View>

                <View className="w-full mt-6">
                    <Text className="text-base font-semibold">密碼</Text>
                    <TextInput
                        className="h-10 bg-gray-200 rounded-lg px-3 mt-2"
                        value={password}
                        onChangeText={setPassword}
                        secureTextEntry
                    />
                    {passwordError && (
                        <Text className="text-red-500 mt-1">{passwordError}</Text>
                    )}
                </View>

                <View className="mt-14">
                    <Pressable
                        className={`w-36 h-12 rounded-full items-center justify-center ${loading ? 'bg-blue-300' : 'bg-blue-500'
                            }`}
                        onPress={login}
                        disabled={loading}
                    >
                        {loading ? (
                            <ActivityIndicator color="#fff" />
                        ) : (
                            <Text className="text-white text-lg font-semibold">登入</Text>
                        )}
                    </Pressable>
                </View>

                <View className="mt-5">
                    <Pressable
                        className="w-36 h-12 bg-gray-500 rounded-full items-center justify-center"
                        onPress={() => Alert.alert('Register', 'Register pressed')}
                    >
                        <Text className="text-white text-lg font-semibold">註冊</Text>
                    </Pressable>
                </View>
            </View>
        </ScrollView>
    )
}
