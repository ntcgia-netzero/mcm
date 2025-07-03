import "../global.css";
import { useEffect } from 'react';
import { View, Text } from 'react-native';
import { useRouter } from 'expo-router';
import Animated, {
    useSharedValue,
    useAnimatedStyle,
    withTiming,
    Easing,
} from 'react-native-reanimated';

export default function EntryScreen() {
    const router = useRouter();
    const scale = useSharedValue(0.8);
    const opacity = useSharedValue(0);

    useEffect(() => {
        opacity.value = withTiming(1, { duration: 800 });
        scale.value = withTiming(1, {
            duration: 800,
            easing: Easing.out(Easing.exp),
        });

        // Redirect
        const timer = setTimeout(() => {
            router.replace('/login');
        }, 2000);

        return () => clearTimeout(timer);
    }, [router, opacity, scale]);

    const animatedStyle = useAnimatedStyle(() => ({
        opacity: opacity.value,
        transform: [{ scale: scale.value }],
    }));

    return (
        <View className="flex-1 bg-white items-center justify-center">
            <Animated.Text
                style={animatedStyle}
                className="text-3xl text-blue-400 tracking-widest text-center"
            >
                <Text className="text-5xl font-bold">M</Text>icro
                <Text className="text-5xl font-bold">C</Text>arbon
                <Text className="text-5xl font-bold">M</Text>anagement
            </Animated.Text>
        </View>
    );
}
