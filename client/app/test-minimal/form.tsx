import { View, Text, TextInput, Pressable, SafeAreaView, KeyboardAvoidingView, Platform, Alert, ScrollView } from "react-native";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { router } from "expo-router";
import { z } from "zod";

// 定義表單驗證
const emissionSchema = z.object({
  electricity: z.string().refine(val => !isNaN(Number(val)) && Number(val) >= 0, {
    message: "請輸入有效的用電量"
  }),
  fuel: z.string().refine(val => !isNaN(Number(val)) && Number(val) >= 0, {
    message: "請輸入有效的燃料用量"
  }),
  refrigerant: z.string().refine(val => !isNaN(Number(val)) && Number(val) >= 0, {
    message: "請輸入有效的冷媒使用量"
  }),
  transportation: z.string().refine(val => !isNaN(Number(val)) && Number(val) >= 0, {
    message: "請輸入有效的員工交通排放量"
  }),
});

type EmissionFormValues = z.infer<typeof emissionSchema>;

export default function EmissionFormScreen() {
  const insets = useSafeAreaInsets();

  const {
    register,
    setValue,
    handleSubmit,
    formState: { errors, isSubmitting }
  } = useForm<EmissionFormValues>({
    resolver: zodResolver(emissionSchema),
    defaultValues: {
      electricity: "",
      fuel: "",
      refrigerant: "",
      transportation: "",
    },
  });

  const onSubmit = async (data: EmissionFormValues) => {
    try {
      console.log("填報資料", data);
      Alert.alert("成功", "已送出綠能碳排資料");
      router.replace("/main");
    } catch (err) {
      Alert.alert("失敗", "提交失敗，請稍後再試");
    }
  };

  return (
    <SafeAreaView
      className="flex-1 bg-white"
      style={{ paddingTop: insets.top, paddingBottom: insets.bottom }}
    >
      <KeyboardAvoidingView
        className="flex-1 px-6"
        behavior={Platform.OS === "ios" ? "padding" : "height"}
      >
        <ScrollView
          className="flex-1"
          keyboardShouldPersistTaps="handled"
          contentContainerStyle={{ paddingVertical: 40 }}
        >
          {/* 頁面標題 */}
          <Text className="text-3xl font-bold mb-8 text-black text-center">綠能碳排填報</Text>

          {/* 卡片區塊 */}
          <View className="bg-white rounded-2xl shadow-2xl p-6 w-full max-w-[400px] mx-auto">
            {/* 小標題 */}
            <Text className="text-lg font-semibold mb-4 text-gray-800">請填寫以下數據</Text>

            {/* 用電量 */}
            <View className="mb-5">
              <Text className="mb-1 text-sm text-gray-700">用電量 (kWh)</Text>
              <TextInput
                className="border-b border-gray-300 py-2 text-base"
                keyboardType="numeric"
                placeholder="請輸入用電量"
                onChangeText={(text) => setValue("electricity", text)}
                {...register("electricity")}
              />
              {errors.electricity && (
                <Text className="text-red-500 text-xs mt-1">{errors.electricity.message}</Text>
              )}
            </View>

            {/* 燃料用量 */}
            <View className="mb-5">
              <Text className="mb-1 text-sm text-gray-700">燃料用量 (公升)</Text>
              <TextInput
                className="border-b border-gray-300 py-2 text-base"
                keyboardType="numeric"
                placeholder="請輸入燃料用量"
                onChangeText={(text) => setValue("fuel", text)}
                {...register("fuel")}
              />
              {errors.fuel && (
                <Text className="text-red-500 text-xs mt-1">{errors.fuel.message}</Text>
              )}
            </View>

            {/* 冷媒使用量 */}
            <View className="mb-5">
              <Text className="mb-1 text-sm text-gray-700">冷媒使用量 (kg)</Text>
              <TextInput
                className="border-b border-gray-300 py-2 text-base"
                keyboardType="numeric"
                placeholder="請輸入冷媒使用量"
                onChangeText={(text) => setValue("refrigerant", text)}
                {...register("refrigerant")}
              />
              {errors.refrigerant && (
                <Text className="text-red-500 text-xs mt-1">{errors.refrigerant.message}</Text>
              )}
            </View>

            {/* 員工交通排放量 */}
            <View className="mb-5">
              <Text className="mb-1 text-sm text-gray-700">員工交通排放量 (kg CO₂)</Text>
              <TextInput
                className="border-b border-gray-300 py-2 text-base"
                keyboardType="numeric"
                placeholder="請輸入員工交通排放量"
                onChangeText={(text) => setValue("transportation", text)}
                {...register("transportation")}
              />
              {errors.transportation && (
                <Text className="text-red-500 text-xs mt-1">{errors.transportation.message}</Text>
              )}
            </View>

            {/* 分隔線 */}
            <View className="border-t border-gray-200 my-4" />

            {/* 送出按鈕 */}
            <Pressable
              className={`mt-3 py-3 rounded-xl ${isSubmitting ? "bg-gray-300" : "bg-black"}`}
              disabled={isSubmitting}
              onPress={handleSubmit(onSubmit)}
            >
              <Text className="text-center text-white text-base font-semibold">
                {isSubmitting ? "送出中..." : "送出填報"}
              </Text>
            </Pressable>
          </View>
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}
