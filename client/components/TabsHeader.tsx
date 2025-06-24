// components/CustomHeader.tsx
import { View, Text } from 'react-native';
import { useState } from 'react';
// import { SelectList } from 'react-native-dropdown-select-list';

export default function TabsHeader({ title = 'Home' }) {
    const [selected, setSelected] = useState('');

    return (
        <View className="flex-row items-center justify-between px-4 py-3 bg-white shadow-md">
            <Text className="text-lg font-bold">{title}</Text>
            <View style={{ width: 120 }} /> {/* spacing symmetry */}
        </View>
    );
}
