import "../global.css";
import { Text, View } from "react-native";

export default function Index() {
    return (
        <View
            style={{
                flex: 1,
                justifyContent: "center",
                alignItems: "center",
            }}
        >
            <Text className="text-red-500 text-2xl font-bold">Hello World</Text>
        </View>
    );
}
