import { View, Text } from 'react-native';
import { useLocalSearchParams } from 'expo-router';

export default function UserPage() {
    const { id } = useLocalSearchParams();

    return (
        <View className="flex-1 items-center justify-center bg-white">
            <Text className="text-lg font-bold">User ID: {id}</Text>
        </View>
    );
}
