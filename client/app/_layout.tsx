import { Slot } from 'expo-router';
import { View, Platform } from 'react-native';
import { useState, useEffect } from 'react';
import { LoadSkiaWeb } from "@shopify/react-native-skia/lib/module/web";

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
    })
    if (!skiaLoaded) {
        return null;
    }
    // -------------- //
    return (
        <View className='flex-1'>
            <Slot />
            {/* <StatusBar style="auto" /> */}
        </View>
    );
}