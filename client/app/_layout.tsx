import { Stack } from 'expo-router';
import { Platform } from 'react-native';
import { useState, useEffect } from 'react';
import { LoadSkiaWeb } from "@shopify/react-native-skia/lib/module/web";
import { SafeAreaProvider } from 'react-native-safe-area-context';
export default function RootLayout() {
    // ---- skia ---- //
    const [skiaLoaded, setSkiaLoaded] = useState(false)
    useEffect(() => {
        if (Platform.OS === 'web') {
            LoadSkiaWeb({ locateFile: () => '/canvaskit.wasm' })
                .then(() => {
                    setSkiaLoaded(true)
                })
        } else {
            setSkiaLoaded(true)
        }
    }, [])
    if (!skiaLoaded) {
        return null;
    }
    // -------------- //
    return <SafeAreaProvider>
        <Stack
            screenOptions={{
                headerShown: false,
            }}
        >
            <Stack.Screen name="index" />
            <Stack.Screen name="login" />
            <Stack.Screen name="signup" />
            <Stack.Screen name="home" />
            <Stack.Screen name="electricity" />
        </Stack>       
    </SafeAreaProvider>
}