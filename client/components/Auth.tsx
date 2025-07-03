import React, { useState } from 'react'
import { Alert, AppState, Text, TextInput, TouchableOpacity, View, ActivityIndicator } from 'react-native'
import { supabase } from '../lib/supabase'

// 註冊 AppState listener
AppState.addEventListener('change', (state) => {
    if (state === 'active') {
        supabase.auth.startAutoRefresh()
    } else {
        supabase.auth.stopAutoRefresh()
    }
})

export default function Auth() {
    const [email, setEmail] = useState('')
    const [password, setPassword] = useState('')
    const [loading, setLoading] = useState(false)

    async function signInWithEmail() {
        setLoading(true)
        const { error } = await supabase.auth.signInWithPassword({
            email: email,
            password: password,
        })
        if (error) Alert.alert(error.message)
        setLoading(false)
    }

    async function signUpWithEmail() {
        setLoading(true)
        const {
            data: { session },
            error,
        } = await supabase.auth.signUp({
            email: email,
            password: password,
        })
        if (error) Alert.alert(error.message)
        if (!session) Alert.alert('Please check your inbox for email verification!')
        setLoading(false)
    }

    return (
        <View className="flex-1 justify-center px-6 bg-white">
            <View className="mb-6">
                <Text className="text-base mb-2 text-gray-700">Email</Text>
                <TextInput
                    className="border border-gray-300 rounded px-4 py-3"
                    placeholder="email@address.com"
                    value={email}
                    autoCapitalize="none"
                    onChangeText={setEmail}
                    keyboardType="email-address"
                />
            </View>
            <View className="mb-6">
                <Text className="text-base mb-2 text-gray-700">Password</Text>
                <TextInput
                    className="border border-gray-300 rounded px-4 py-3"
                    placeholder="Password"
                    value={password}
                    autoCapitalize="none"
                    secureTextEntry
                    onChangeText={setPassword}
                />
            </View>

            {loading && (
                <ActivityIndicator size="large" className="mb-4" />
            )}

            <TouchableOpacity
                className="bg-blue-600 rounded p-4 mb-4"
                onPress={signInWithEmail}
                disabled={loading}
            >
                <Text className="text-white text-center font-semibold">Sign in</Text>
            </TouchableOpacity>

            <TouchableOpacity
                className="border border-blue-600 rounded p-4"
                onPress={signUpWithEmail}
                disabled={loading}
            >
                <Text className="text-blue-600 text-center font-semibold">Sign up</Text>
            </TouchableOpacity>
        </View>
    )
}
